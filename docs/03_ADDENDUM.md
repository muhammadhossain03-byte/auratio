# 03_ADDENDUM.md — Database Design & Schema Traceability

> **Course:** CSE311L Database Systems Lab · Section 3 · Group 9  
> **Project:** Auratio — Public Speaking & Presentation Skill Development Platform  
> **Authors:** Muhammad Rafid Hossain (2231895642), Masuma Khan Trisha (2121336642), Ushrika Mostafa Mou (2222587042), Ahnaf Akif (2122286042)

---

## 1. Schema Fidelity & Scope Confirmation

> [!NOTE]
> **Zero Deviation from Submitted ERD:**  
> The database implementation in [`database/schema.sql`](../database/schema.sql) strictly mirrors the Entity-Relationship Diagram (ERD) submitted to the instructor. **No table, attribute, primary key, foreign key, or constraint has been added, removed, renamed, or simplified.**
>
> All 22 entities are implemented as InnoDB tables. All 29 foreign keys and 14 CHECK constraints are enforced at the database engine level. The only difference between the theoretical proposal and this implementation is that **live AI model inference (API calls to LLMs/audio models) was omitted**; the `ai_specialist_agent` table holds seeded evaluation agent profiles and the `evaluation.agent_id` foreign key points to them, satisfying the XOR evaluator constraint (`chk_ev_source`) in pure SQL.

---

## 2. PascalCase (ERD) to snake_case (MySQL) Table Mapping

In accordance with SQL naming conventions, entity names from the PascalCase ERD are represented in standard `snake_case` in MySQL:

| # | ERD Entity (PascalCase) | MySQL Table Name (snake_case) | Engine | Cardinality / Description |
|---|---|---|---|---|
| 1 | `UserAccount` | `user_account` | InnoDB | Platform users (learners, evaluators, organizers, admins) |
| 2 | `AccessRole` | `access_role` | InnoDB | System roles (`Learner`, `Evaluator`, `Administrator`, `Organizer`) |
| 3 | `AccessPermission` | `access_permission` | InnoDB | Granular permissions (`curriculum.manage`, `submission.create`, etc.) |
| 4 | `RolePermission` | `role_permission` | InnoDB | Bridge table linking permissions to roles |
| 5 | `UserRoleAssignment` | `user_role_assignment` | InnoDB | Bridge table assigning roles to users (supports multi-role users) |
| 6 | `SpeechFormat` | `speech_format` | InnoDB | Delivery formats (`Informative`, `Persuasive`, `Impromptu`, etc.) |
| 7 | `SpeakingSkill` | `speaking_skill` | InnoDB | Evaluated skills (`Vocal Clarity`, `Body Language`, `Structure`, etc.) |
| 8 | `RubricCriterion` | `rubric_criterion` | InnoDB | Weighted evaluation criteria per speech format |
| 9 | `AiSpecialistAgent` | `ai_specialist_agent` | InnoDB | AI evaluation agent configurations and versions |
| 10 | `Curriculum` | `curriculum` | InnoDB | Structured speaking curricula |
| 11 | `CurriculumModule` | `curriculum_module` | InnoDB | Sequential learning modules belonging to a curriculum |
| 12 | `Milestone` | `milestone` | InnoDB | Achievement badges and completion milestones |
| 13 | `CurriculumEnrollment` | `curriculum_enrollment` | InnoDB | Tracks learner enrollments and completion timestamps |
| 14 | `ModuleProgress` | `module_progress` | InnoDB | Progress status per module under an active enrollment |
| 15 | `SpeechSubmission` | `speech_submission` | InnoDB | Practice video submissions, attempt numbers, and metadata |
| 16 | `Evaluation` | `evaluation` | InnoDB | Assessment scores and reviews (AI or Human evaluator) |
| 17 | `EvaluationSkillScore` | `evaluation_skill_score` | InnoDB | Granular rubric criterion scores per evaluation |
| 18 | `UserMilestone` | `user_milestone` | InnoDB | Milestones earned by individual users |
| 19 | `Community` | `community` | InnoDB | Speaking clubs and academic presentation societies |
| 20 | `CommunityMembership` | `community_membership` | InnoDB | Member affiliations and community roles |
| 21 | `CommunityEvent` | `community_event` | InnoDB | Workshops, masterclasses, and speech contests |
| 22 | `EventRegistration` | `event_registration` | InnoDB | Participant registrations and attendance statuses |

---

## 3. List of All 29 Foreign Keys

Every foreign key defined in the ERD is implemented with appropriate `ON DELETE` / `ON UPDATE` actions (`CASCADE` for child dependencies, `RESTRICT` for historical integrity):

1. **`ai_specialist_agent.format_id`** → `speech_format.format_id` (Constraint: `fk_agent_format`)
2. **`community.created_by_user_id`** → `user_account.user_id` (Constraint: `fk_com_creator`)
3. **`community_event.community_id`** → `community.community_id` (Constraint: `fk_cev_community`)
4. **`community_event.organizer_user_id`** → `user_account.user_id` (Constraint: `fk_cev_organizer`)
5. **`community_membership.community_id`** → `community.community_id` (Constraint: `fk_cmem_community`)
6. **`community_membership.user_id`** → `user_account.user_id` (Constraint: `fk_cmem_user`)
7. **`curriculum_enrollment.curriculum_id`** → `curriculum.curriculum_id` (Constraint: `fk_ce_curriculum`)
8. **`curriculum_enrollment.learner_id`** → `user_account.user_id` (Constraint: `fk_ce_learner`)
9. **`curriculum_module.curriculum_id`** → `curriculum.curriculum_id` (Constraint: `fk_cm_curriculum`)
10. **`curriculum_module.format_id`** → `speech_format.format_id` (Constraint: `fk_cm_format`)
11. **`evaluation.agent_id`** → `ai_specialist_agent.agent_id` (Constraint: `fk_ev_agent`)
12. **`evaluation.human_evaluator_id`** → `user_account.user_id` (Constraint: `fk_ev_human`)
13. **`evaluation.submission_id`** → `speech_submission.submission_id` (Constraint: `fk_ev_submission`)
14. **`evaluation_skill_score.criterion_id`** → `rubric_criterion.criterion_id` (Constraint: `fk_ess_criterion`)
15. **`evaluation_skill_score.evaluation_id`** → `evaluation.evaluation_id` (Constraint: `fk_ess_eval`)
16. **`event_registration.event_id`** → `community_event.event_id` (Constraint: `fk_er_event`)
17. **`event_registration.user_id`** → `user_account.user_id` (Constraint: `fk_er_user`)
18. **`milestone.curriculum_id`** → `curriculum.curriculum_id` (Constraint: `fk_ms_curriculum`)
19. **`module_progress.enrollment_id`** → `curriculum_enrollment.enrollment_id` (Constraint: `fk_mp_enrollment`)
20. **`module_progress.module_id`** → `curriculum_module.module_id` (Constraint: `fk_mp_module`)
21. **`role_permission.permission_id`** → `access_permission.permission_id` (Constraint: `fk_rp_perm`)
22. **`role_permission.role_id`** → `access_role.role_id` (Constraint: `fk_rp_role`)
23. **`rubric_criterion.format_id`** → `speech_format.format_id` (Constraint: `fk_rc_format`)
24. **`rubric_criterion.skill_id`** → `speaking_skill.skill_id` (Constraint: `fk_rc_skill`)
25. **`speech_submission.module_progress_id`** → `module_progress.module_progress_id` (Constraint: `fk_ss_progress`)
26. **`user_milestone.milestone_id`** → `milestone.milestone_id` (Constraint: `fk_um_milestone`)
27. **`user_milestone.user_id`** → `user_account.user_id` (Constraint: `fk_um_user`)
28. **`user_role_assignment.role_id`** → `access_role.role_id` (Constraint: `fk_ura_role`)
29. **`user_role_assignment.user_id`** → `user_account.user_id` (Constraint: `fk_ura_user`)

---

## 4. Feature-to-Tab Traceability Matrix

The six core functional requirements from the project proposal map directly to the five single-page tabs in `index.html`:

| # | Proposal Feature | Implemented Database Model | UI Tab Location | Interactive Capabilities |
|---|---|---|---|---|
| **1** | **Structured Curricula** | `curriculum`, `curriculum_module`, `speech_format` | **Curricula** | Full CRUD on curricula; dynamic module listing; difficulty pills |
| **2** | **Practice Submissions** | `speech_submission`, `module_progress`, `curriculum_enrollment` | **Submissions** | Full CRUD on submissions; attempt tracking; video URI; format linkage |
| **3** | **AI or Human Evaluator** | `evaluation`, `ai_specialist_agent`, `user_account` | **Submissions** *(Add Evaluation)* | Create & Read evaluations; dynamic UI toggle enforcing the XOR source constraint |
| **4** | **Progress Dashboard** | `evaluation`, `evaluation_skill_score`, `module_progress`, `curriculum_enrollment` | **Dashboard** | Real-time KPI counts; SQL-aggregated completion bars & average skill scores |
| **5** | **Community Events & Registrations** | `community`, `community_event`, `event_registration`, `community_membership` | **Community** | Full CRUD on community events; capacity tracking; user event registrations |
| **6** | **Role-Based Users** | `user_account`, `access_role`, `user_role_assignment`, `access_permission` | **Users** | Full CRUD on user accounts; multi-role chip display; delete constraint protection |
